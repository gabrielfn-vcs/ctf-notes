import datetime

import jwt
from flask import current_app
from app import db, bcrypt


class Operator(db.Model):
    __tablename__ = "operator"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    admin = db.Column(db.Boolean, default=False, nullable=False)
    username = db.Column(db.String(128), unique=True, nullable=False)
    email = db.Column(db.String(128), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    avatar = db.Column(db.String(255), nullable=True)

    def __init__(self, username, admin, email, name, password):
        self.username = username
        self.admin = admin
        self.email = email
        self.name = name
        self.password = bcrypt.generate_password_hash(
            password, current_app.config.get('BCRYPT_LOG_ROUNDS')
        ).decode()

    def encode_auth_token(self, user_id):
        try:
            payload = {
                'exp': datetime.datetime.utcnow() + datetime.timedelta(
                    days=current_app.config.get('TOKEN_EXPIRATION_DAYS'),
                    seconds=current_app.config.get('TOKEN_EXPIRATION_SECONDS')
                ),
                'iat': datetime.datetime.utcnow(),
                'sub': user_id
            }
            return jwt.encode(
                payload,
                current_app.config.get('SECRET_KEY'),
                algorithm='HS256'
            )
        except jwt.exceptions.PyJWTError as e:
            app.logger.error(
                f"There was an issue creating the auth token for user: {e}")
            return None

    @staticmethod
    def decode_auth_token(auth_token):

        try:
            payload = jwt.decode(
                auth_token, current_app.config.get('SECRET_KEY'), algorithms=["HS256"])
            return payload['sub']
        except jwt.ExpiredSignatureError:
            return 'Signature expired. Please log in again.'
        except jwt.InvalidTokenError:
            return 'Invalid token. Please log in again.'


class Obstacle(db.Model):
    __tablename__ = "obstacles"
    name = db.Column(db.String(128), primary_key=True)
    rate = db.Column(db.Integer, nullable=False)
    operational = db.Column(db.Boolean, default=True, nullable=False)
    img_name = db.Column(db.String(128), nullable=False)
    description = db.Column(db.String(255), nullable=False)

    def __init__(self, name, rate, operational, img_name, description):
        self.name = name
        self.rate = rate
        self.operational = operational
        self.img_name = img_name
        self.description = description


class ObstacleLog(db.Model):
    __tablename__ = "obstacle_log"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    obstacle = db.Column(db.String(128), db.ForeignKey("obstacles.name"))
    operator = db.Column(db.Integer, db.ForeignKey("operator.id"))
    timestamp = db.Column(db.DateTime(timezone=True),
                          server_default=db.func.now())
    operational_at_time = db.Column(db.Boolean, default=True, nullable=False)
    rate_at_time = db.Column(db.Integer, nullable=False)

    def __init__(self, obstacle, operator, operational_at_time, rate_at_time):
        self.obstacle = obstacle
        self.operator = operator
        self.operational_at_time = operational_at_time
        self.rate_at_time = rate_at_time
