import functools

from flask import request, jsonify, redirect, url_for, flash

import models


def authenticate(f):
    @functools.wraps(f)
    def decorated_function(*args, **kwargs):
        response_object = {
            'status': 'fail',
            'message': 'Provide a valid auth token.'
        }
        auth_token = request.cookies.get('Authorization')
        if not auth_token:
            return jsonify(response_object), 403
        resp = models.Operator.decode_auth_token(auth_token)
        if isinstance(resp, str):
            response_object['message'] = resp
            return jsonify(response_object), 401
        user = models.Operator.query.filter_by(id=resp).first()
        if not user:
            return jsonify(response_object), 401
        return f(resp, *args, **kwargs)

    return decorated_function


def login_required(view):
    """View decorator that redirects anonymous operators to the login page."""

    @functools.wraps(view)
    def wrapped_view(**kwargs):
        auth_token = request.cookies.get('Authorization')
        if not auth_token:
            flash("Please log in first")
            return redirect(url_for("auth.login"))

        return view(**kwargs)

    return wrapped_view


def get_operator(request):
    """ Gets the currently logged in user """
    auth_token = request.cookies.get('Authorization')
    if auth_token:
        resp = models.Operator.decode_auth_token(auth_token)
        if not isinstance(resp, str):
            return models.Operator.query.filter_by(id=resp).first()
    return None
