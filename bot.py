import signal
import sys
import yaml
from telegram import Update
from telegram.ext import Application, filters, ContextTypes, MessageHandler

# Load config from file
with open("config.yaml", "r") as config_file:
    config = yaml.safe_load(config_file)

TOKEN = config["token"]
FORWARD_TO = config["forward_to"]
WELCOME_MESSAGE = config["welcome_message"]


async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if not update.message:
        return

    message = update.message
    if message.new_chat_members:
        # Send welcome message to new members
        for new_member in message.new_chat_members:
            await context.bot.send_message(chat_id=new_member.id, text=WELCOME_MESSAGE)
    else:
        if message.text and message.text.startswith("/"):
            return

        print("Forwarding message from={0}, message={1}".format(message.chat.id, message.text))
        await context.bot.forward_message(chat_id=FORWARD_TO, from_chat_id=message.chat.id,
                                          message_id=message.message_id)


def exit_handler(signal, frame):
    print("Received {0}, shutting down gracefully...".format(signal))
    sys.exit(0)


if __name__ == '__main__':
    # Register signal handlers
    signal.signal(signal.SIGTERM, exit_handler)
    signal.signal(signal.SIGINT, exit_handler)

    # Build the application
    application = Application.builder().token(TOKEN).build()
    application.add_handler(MessageHandler(filters.ALL, handle_message))
    application.run_polling(allowed_updates=Update.ALL_TYPES)
