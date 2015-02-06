package org.tttalk.openfire.plugin;

import java.io.File;
import java.util.Map;

import org.jivesoftware.openfire.MessageRouter;
import org.jivesoftware.openfire.SharedGroupException;
import org.jivesoftware.openfire.XMPPServer;
import org.jivesoftware.openfire.container.Plugin;
import org.jivesoftware.openfire.container.PluginManager;
import org.jivesoftware.openfire.event.UserEventDispatcher;
import org.jivesoftware.openfire.event.UserEventListener;
import org.jivesoftware.openfire.user.User;
import org.jivesoftware.openfire.user.UserAlreadyExistsException;
import org.jivesoftware.openfire.user.UserManager;
import org.jivesoftware.util.JiveGlobals;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xmpp.packet.JID;
import org.xmpp.packet.Message;

/**
 * Registration plugin.
 *
 * @author Ryan Graham.
 */
public class RegistrationPlugin implements Plugin {

	private static final Logger Log = LoggerFactory
			.getLogger(RegistrationPlugin.class);

	private static final String TTTALK_USER_TRANSLATOR = "tttalk.user.translator";
	// TODO
	private static final String TTTALK_USER_SERVICE = "tttalk.user.service";
	private static final String TTTALK_USER_VOLUNTEER = "tttalk.user.volunteer";
	private final String defaultFriendsList[] = new String[] {
			TTTALK_USER_TRANSLATOR, TTTALK_USER_SERVICE, TTTALK_USER_VOLUNTEER };

	private RegistrationUserEventListener listener = new RegistrationUserEventListener();

	private final String serverName;
	private JID serverAddress;
	private MessageRouter router;

	private final UserManager userManager;

	private final XMPPServer server;

	public RegistrationPlugin() {
		server = XMPPServer.getInstance();

		serverName = server.getServerInfo().getXMPPDomain();
		serverAddress = new JID(serverName);
		router = server.getMessageRouter();

		userManager = server.getUserManager();
		server.getRosterManager();

		UserEventDispatcher.addListener(listener);
	}

	@Override
	public void initializePlugin(PluginManager manager, File pluginDirectory) {
	}

	@Override
	public void destroyPlugin() {
		UserEventDispatcher.removeListener(listener);
		serverAddress = null;
		listener = null;
		router = null;
	}

	public void setTranslator(String translator) {
		JiveGlobals.setProperty(TTTALK_USER_TRANSLATOR, translator);
	}

	public String getTranslator() {
		return JiveGlobals.getProperty(TTTALK_USER_TRANSLATOR);
	}

	public String getVolunteer() {
		return JiveGlobals.getProperty(TTTALK_USER_VOLUNTEER);
	}

	public String getService() {
		return JiveGlobals.getProperty(TTTALK_USER_SERVICE);
	}

	private class RegistrationUserEventListener implements UserEventListener {
		@Override
		public void userCreated(User user, Map<String, Object> params) {
			for (int i = 0; i < defaultFriendsList.length; i++) {
				String friendName = JiveGlobals
						.getProperty(defaultFriendsList[i]);
				if (friendName != null && friendName.trim().length() > 0) {
					try {
						User translator = userManager.getUser(friendName);

						addFriendToUser(user, translator);
						addFriendToUser(translator, user);

						router.route(createServerMessage(user.getName(),
								"notice", friendName + " add you as friend."));
					} catch (Exception e) {
						e.printStackTrace();
						Log.error(e.getMessage(), e);
					}
				}
			}
		}

		@Override
		public void userDeleting(User user, Map<String, Object> params) {
		}

		@Override
		public void userModified(User user, Map<String, Object> params) {
		}

	}

	private Message createServerMessage(String to, String subject, String body) {
		Message message = new Message();
		message.setTo(to);
		message.setFrom(serverAddress);
		if (subject != null) {
			message.setSubject(subject);
		}
		message.setBody(body);
		return message;
	}

	public void addFriendToUser(User user, User friend)
			throws UserAlreadyExistsException, SharedGroupException {

		user.getRoster().createRosterItem(
				server.createJID(friend.getUsername(), null), true, true);
	}

}
