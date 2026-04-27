import logging
from logging.handlers import RotatingFileHandler

from flask import Flask
from flask_bcrypt import Bcrypt
from flask_sqlalchemy import SQLAlchemy


def create_app(script_info=None):
    # instantiate app
    app = Flask(__name__, static_url_path='', static_folder="static")

    # set configuration
    app.config.from_object('config.DevelopmentConfig')

    # set up extensions
    db.init_app(app)
    bcrypt.init_app(app)

    # register blueprints
    from ride import operator_blueprint
    app.register_blueprint(operator_blueprint)

    from auth import auth_blueprint
    app.register_blueprint(auth_blueprint)

    from dashboard import dashboard_blueprint
    app.register_blueprint(dashboard_blueprint)

    # shell context for flask cli
    app.shell_context_processor({'app': app, 'db': db})

    # Logging
    handler = RotatingFileHandler('flask.log', maxBytes=10000, backupCount=1)
    handler.setLevel(logging.INFO)
    app.logger.addHandler(handler)

    return app


db = SQLAlchemy()
bcrypt = Bcrypt()

app = create_app()
