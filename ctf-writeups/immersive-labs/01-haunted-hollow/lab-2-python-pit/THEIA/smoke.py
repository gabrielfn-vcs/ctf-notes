import logging
import os


class SmokeMachine:
    counter = 0
    rate_exceeded = False

    @staticmethod
    def setup_logger():
        logging.basicConfig(
            filename="smoke_log.log",
            level=logging.INFO,
            format="%(asctime)s - %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
        )

    @staticmethod
    def pump():
        if not os.path.exists("smoke_log.log"):
            SmokeMachine.setup_logger()

        SmokeMachine.counter += 1

        if SmokeMachine.counter > 100:
            if not SmokeMachine.rate_exceeded:
                logging.info(
                    "smoke rate dangerously high - pumped: %s times\n"
                    % SmokeMachine.counter
                )
            SmokeMachine.rate_exceeded = True

    @staticmethod
    def shut_off():
        SmokeMachine.counter = 0
        SmokeMachine.rate_exceeded = False
        logging.info("smoke machine shut off\n")
