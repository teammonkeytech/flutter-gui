High level overview:

Make a user ID and Username, then authenticate, by sending username, plaintext password and public key in.

Then:
1. Use username to request new bubble from server, or
2. Invite another user to current bubble by sending new user uid and bid in

Send a message by fetching all users in bubble, encrypting all messages with recipients' public keys individually, and sending them all back.

Get messages by loading all messages from server, then attempting to decrypt all of them and taking only the ones that can actually be decrypted.
Messages are returned from the server as a JSON array