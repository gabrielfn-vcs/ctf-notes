from flask import Blueprint, request, redirect, url_for, render_template, abort, flash
from sqlalchemy import desc
from app import db
import models
import utils
import smoke

dashboard_blueprint = Blueprint(
    "dashboard", __name__, template_folder="./templates")


@dashboard_blueprint.route("/dashboard", methods=["GET"])
def feed():
    operator_id = request.args.get("operator_id")
    operator = utils.get_operator(request)
    obstacles = models.Obstacle.query.order_by(
        desc(models.Obstacle.name)).all()
    logs = models.ObstacleLog.query.order_by(
        desc(models.ObstacleLog.timestamp)).all()
    for log in logs:
        if log.rate_at_time > 100 or log.rate_at_time < 1:
            logging.info(f'Deleting invalid log entry with rate {log.rate_at_time} for {log.obstacle} obstacle')
            try:
                db.session.delete(log)
                db.commit()
            except:
                logging.info('Unable to delete obstacle log entry')
                db.session.rollback()
    return render_template("dashboard.html", operator=operator.name, obstacles=obstacles, logs=logs, operator_id=operator_id
    )


@dashboard_blueprint.route("/dashboard/rate/python", methods=["POST"])
def rate_pythons():
    user_agent = request.user_agent
    logging.info(f"{request}, User-Agent: {user_agent}")
    if "python-requests" in user_agent or "curl" in user_agent:
        logging.info(f"Invalid User-Agent: {user_agent}")
        return "Invalid User-Agent", 403  # Block requests from scripts

    rate = request.form.get("rate", type=int)
    logging.info(f"Updating Pythons rate to {rate}")
    if rate is None or rate < 1 or rate > 100:
        logging.info("Pythons rate must be between 0 and 100")
        return redirect(url_for("dashboard.feed"))
    obstacle = models.Obstacle.query.filter_by(name="pythons").first()
    if not obstacle:
        abort(404)
    obstacle.rate = rate
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        flash(f"Failed to update rate: {e}")
        return redirect(url_for("dashboard.feed"))
    log = models.ObstacleLog(
        obstacle="pythons",
        operator=utils.get_operator(request).id,
        operational_at_time=obstacle.operational,
        rate_at_time=rate,
    )
    db.session.add(log)
    db.session.commit()
    flash("Pythons rate updated successfully")
    return redirect(url_for("dashboard.feed"))


@dashboard_blueprint.route("/dashboard/rate/rumble", methods=["POST"])
def rate_rumble():
    rate = request.form["rate"]
    if int(rate) > 100 or int(rate) < 0:
        flash("Rate must be between 0 and 100")
        return redirect(url_for("dashboard.feed"))
    obstacle = models.Obstacle.query.filter_by(name="rumble").first()
    if not obstacle:
        abort(404)
    obstacle.rate = rate
    db.session.commit()
    log = models.ObstacleLog(
        obstacle="rumble",
        operator=utils.get_operator(request).id,
        operational_at_time=obstacle.operational,
        rate_at_time=rate,
    )
    db.session.add(log)
    db.session.commit()
    flash("Rumble rate updated successfully")
    return redirect(url_for("dashboard.feed"))


@dashboard_blueprint.route("/dashboard/rate/smoke", methods=["POST"])
def rate_smoke():
    pump_rate = request.form["rate"]
    pump_rate = int(pump_rate)
    if pump_rate > 100:
        flash("Rate must be lower than 100")
        return redirect(url_for("dashboard.feed"))
    obstacle = models.Obstacle.query.filter_by(name="smoke").first()
    if not obstacle:
        abort(404)
    obstacle.rate = pump_rate
    db.session.commit()
    log = models.ObstacleLog(
        obstacle="smoke",
        operator=utils.get_operator(request).id,
        operational_at_time=obstacle.operational,
        rate_at_time=pump_rate,
    )
    db.session.add(log)
    db.session.commit()
    # pump smoke from machine at the rate we receive after we've updated the db
    # this should never exceed 100 pumps
    while pump_rate != 0:
        pump_rate -= 1
        smoke.SmokeMachine.pump()
    smoke.SmokeMachine.shut_off() # safely shut off machine
    flash("Smoke rate updated successfully")
    return redirect(url_for("dashboard.feed"))


@dashboard_blueprint.route("/dashboard/rate/pegs", methods=["POST"])
def rate_pegs():
    rate = request.form["rate"]
    if int(rate) > 100 or int(rate) < 0:
        flash("Rate must be between 0 and 100")
        return redirect(url_for("dashboard.feed"))
    obstacle = models.Obstacle.query.filter_by(name="pegs").first()
    if not obstacle:
        abort(404)
    obstacle.rate = rate
    db.session.commit()
    log = models.ObstacleLog(
        obstacle="pegs",
        operator=utils.get_operator(request).id,
        operational_at_time=obstacle.operational,
        rate_at_time=rate,
    )
    db.session.add(log)
    db.session.commit()
    flash("Smoke rate updated successfully")
    return redirect(url_for("dashboard.feed"))
