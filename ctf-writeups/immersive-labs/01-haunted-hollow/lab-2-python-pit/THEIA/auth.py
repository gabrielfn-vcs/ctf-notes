import models
import utils
from app import bcrypt, db
from flask import (
    Blueprint,
    flash,
    make_response,
    redirect,
    render_template,
    request,
    url_for,
)

from sqlalchemy import exc, or_

auth_blueprint = Blueprint("auth", __name__)


@auth_blueprint.route("/auth/signup", methods=["GET", "POST"])
def signup():
    logging.info('------------------------------')
    logging.info(f'/auth/signup: {request}')
    logging.info(f'-> form data={request.form}')
    logging.info(f'-> received from IP: {request.remote_addr}, User-Agent: {request.user_agent}')
    logging.info(f'-> headers: {request.headers}')
    logging.info('------------------------------')

    if request.method == "GET":
        session_csrf_token = os.urandom(24).hex()
        logging.info(f'Creating CSRF Token: {session_csrf_token}')
        session['csrf_token'] = session_csrf_token
        # Include this token in the form (in HTML):
        # <input type="hidden" name="csrf_token" value="{{ csrf_token }}">
        return render_template('signup.html', csrf_token=session['csrf_token'])

    if request.method == "POST":
        form_csrf_token = request.form.get('csrf_token')
        session_csrf_token = session.get('csrf_token')
        logging.info(f'Checking form CSRF token: {form_csrf_token} against session CSRF token: {session_csrf_token}')
        if not form_csrf_token or form_csrf_token != session_csrf_token:
            return "Invalid CSRF token", 400  # Block the request if CSRF token is invalid

        name = request.form["name"]
        username = request.form["username"]
        email = request.form["email"]
        password = request.form["password"]
        admin = request.form["admin"]
        try:
            user = models.Operator.query.filter(
                or_(
                    models.Operator.username == username, models.Operator.email == email
                )
            ).first()
            if not user:
                logging.info(f'Creating user: name={name}, username={username}, email={email}, password={password}, admin={admin}')
                new_user = models.Operator(
                    username=username, admin=int(admin), email=email, password=password, name=name
                )
                db.session.add(new_user)
                db.session.commit()
                auth_token = new_user.encode_auth_token(new_user.id)
                if auth_token:
                    response = make_response(redirect(url_for("dashboard.feed")))
                    response.set_cookie("Authorization", auth_token, httponly=True)
                    return response
                return "Sorry there was an error creating a new user"
            else:
                return "Sorry that username or email already exists"
        except (exc.IntegrityError, ValueError) as e:
            app.logger.error(f"Failed to sign up user - Database error occurred: {e}")
            db.session.rollback()
            return "Signup failed", 400
    return render_template("signup.html")



@auth_blueprint.route("/auth/login", methods=["GET", "POST"])
def login():
    logging.info('------------------------------')
    logging.info(f'/auth/login: {request}')
    logging.info(f'-> form data={request.form}')
    logging.info(f'-> received from IP: {request.remote_addr}, User-Agent: {request.user_agent}')
    logging.info(f'-> headers: {request.headers}')
    logging.info('------------------------------')

    # user_agent = request.user_agent
    # if "python-requests" in user_agent or "curl" in user_agent:
    #     return "Invalid User-Agent", 403  # Block requests from scripts

    if request.method == "GET":
        operators = models.Operator.query.order_by(desc(models.Operator.name)).all()
        for operator in operators:
            # logging.info(f'id={operator.id}, name={operator.name}, username={operator.username}, email={operator.email}, admin={operator.admin}')
            if operator.admin:
                logging.info(f'Deleting operator with admin flag: {operator.name}')
                try:
                    db.session.delete(operator)
                    db.session.commit()
                except Exception as e:
                    logging.info(f'Unable to delete operator: {e}')
                    db.session.rollback()

    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        try:
            # fetch user data
            operator = models.Operator.query.filter_by(email=email).first()
            if operator and bcrypt.check_password_hash(operator.password, password):
                logging.info(f'Found user: name={operator.name}, username={operator.username}, email={operator.email}, admin={operator.admin}')
                auth_token = operator.encode_auth_token(operator.id)
                if auth_token:
                    response = make_response(redirect(url_for("dashboard.feed")))
                    response.set_cookie("Authorization", auth_token, httponly=True)
                    return response
        except exc.SQLAlchemyError as e:
            app.logger.error(f"Database error occurred: {e}")
        except (ValueError, TypeError) as e:
            app.logger.error(f"Password hash error occurred: {e}")
        # If we get here login has failed
        flash("Login failed")

    return render_template("login.html")


@auth_blueprint.route("/auth/logout", methods=["GET"])
def logout():
    response = make_response(redirect(url_for("auth.login")))
    response.set_cookie("Authorization", expires=0)
    return response


@auth_blueprint.route("/auth/status", methods=["GET"])
def status():
    user = utils.get_operator(request)
    if user:
        return str(user.id)
    return "Please provide a valid token.", 401
