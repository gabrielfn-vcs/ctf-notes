import emoji


# All the emojis available for input code
all_emojis = "🎃👺🧟🕷️🕸️🧛👻🤡💀☠️🍬🍭⚰️🌕🕯️"
print(f'All possible emojis: {all_emojis}')
last_unicode_value = ''
for emoji_char in all_emojis:
    unicode_value = emoji_char.encode('unicode-escape').decode('ASCII')
    n_bytes = len(emoji_char.encode('utf-8'))
    if n_bytes == 4:
        last_unicode_value = unicode_value
    else:
        unicode_value = last_unicode_value + unicode_value.replace('\\u', '\\U0000')
    print(f'{emoji_char} {emoji.demojize(emoji_char)} {unicode_value}')

# Expected input emojis
emoji_input = "🕯️🕷️🧟🎃🌕💀🧛🕸️👻🕯️"
print(f'Input emojis: {emoji_input}')

# Convert the input emojis into unicode
# '\U0001f56f\U0000fe0f\U0001f577\U0000fe0f\U0001f9df\U0001f383\U0001f315\U0001f480\U0001f9db\U0001f578\U0000fe0f\U0001f47b\U0001f56f\U0000fe0f'
emoji_input_unicode = "🕯️🕷️🧟🎃🌕💀🧛🕸️👻🕯️".encode('unicode-escape').decode('ASCII').replace('\\u', '\\U0000')
print(f'Input emojis as unicode: {emoji_input_unicode}')
