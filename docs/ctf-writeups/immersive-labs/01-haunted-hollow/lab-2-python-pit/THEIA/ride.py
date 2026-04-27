from flask import Blueprint, jsonify, redirect, url_for, request, flash

import utils
from os import path
from flask import current_app
from app import db
operator_blueprint = Blueprint(
    "operator", __name__, template_folder="./templates", static_folder="./static"
)


@operator_blueprint.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "success", "message": "check"})


@operator_blueprint.route("/", methods=["GET"])
@utils.login_required
def index():
    return redirect(url_for("dashboard.feed"))


@operator_blueprint.route("/operator/avatar", methods=["GET"])
def avatar():
    operator = utils.get_operator(request)
    if not operator:
        return redirect(url_for("auth.login"))
    return redirect("/static/img/avatar" + operator.avatar)

@operator_blueprint.route("/operator/upload/avatar", methods=["POST"])
def upload_avatar():
    if 'file' not in request.files:
        return 'No file part'
    file = request.files['file']
    if file.filename == '':
        flash('No selected file')
        return redirect(url_for("dashboard.feed"))
    if file:
        filename = file.filename
        file.save(path.join(current_app.root_path, 'static/avatar', filename))
        operator = utils.get_operator(request)
        operator.avatar = filename
        db.session.commit()
        flash('File uploaded successfully')
        return redirect(url_for("dashboard.feed"))


