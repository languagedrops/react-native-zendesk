package io.dcvz.rnzendesk;

import zendesk.core.Zendesk;
import zendesk.core.Identity;
import zendesk.core.JwtIdentity;
import zendesk.support.Support;
import zendesk.support.UiConfig;
import zendesk.support.guide.HelpCenterActivity;
import zendesk.support.request.RequestActivity;

import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.ArrayList;
import java.util.stream.Collectors;

public class RNZendeskBridge extends ReactContextBaseJavaModule {

    public RNZendeskBridge(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNZendesk";
    }

    // MARK: - Initialization

    @ReactMethod
    public void initialize(ReadableMap config) {
        String appId = config.getString("appId");
        String zendeskUrl = config.getString("zendeskUrl");
        String clientId = config.getString("clientId");

        Zendesk.INSTANCE.init(getReactApplicationContext(), zendeskUrl, appId, clientId);
        Support.INSTANCE.init(Zendesk.INSTANCE);
    }

    // MARK: - Indentification

    @ReactMethod
    public void identifyJWT(String token) {
        JwtIdentity identity = new JwtIdentity(token);
        Zendesk.INSTANCE.setIdentity(identity);
    }

    @ReactMethod
    public void identifyAnonymous(String name, String email) {
        Identity identity = new AnonymousIdentity.Builder()
        .withNameIdentifier(name)
        .withEmailIdentifier(email)
        .build();

        Zendesk.INSTANCE.setIdentity(identity);
    }

    // MARK: - UI Methods

    @ReactMethod
    public void showHelpCenter(ReadableMap options) {
        ArrayList fields = options.getArray("fields")
            .stream()
            .filter(field -> field.hasKey("id") && field.hasKey("value"))
            .map(filed -> new CustomField(field.getInt("id"), field.getString("value")))
            .collect(Collectors.toCollection(ArrayList::new));

        UiConfig ticketsConfig = RequestActivity.builder()
            .withCustomFields(fields)
            .config();


        HelpCenterActivity.builder()
            .withContactUsButtonVisible(!(options.hasKey("hideContactSupport") && options.getBoolean("hideContactSupport")))
            .show(getReactApplicationContext(), ticketsConfig);
    }

    @ReactMethod
    public void showNewTicket(ReadableMap options) {
        ArrayList tags = options.getArray("tags").toArrayList();

        ArrayList fields = options.getArray("fields")
            .stream()
            .filter(field -> field.hasKey("id") && field.hasKey("value"))
            .map(filed -> new CustomField(field.getInt("id"), field.getString("value")))
            .collect(Collectors.toCollection(ArrayList::new));

        RequestActivity.builder()
                .withTags(tags)
                .withCustomFields(fields)
                .show(getReactApplicationContext());
    }

    @ReactMethod
    public void showTickets(ReadableMap options) {
        ArrayList tags = options.getArray("tags").toArrayList();

        ArrayList fields = options.getArray("fields")
            .stream()
            .filter(field -> field.hasKey("id") && field.hasKey("value"))
            .map(filed -> new CustomField(field.getInt("id"), field.getString("value")))
            .collect(Collectors.toCollection(ArrayList::new));

        UiConfig ticketsConfig = RequestActivity.builder()
                .withTags(tags)
                .withCustomFields(fields)
                .config();

        RequestListActivity.builder()
            .show(getReactApplicationContext(), ticketsConfig);
    }
}
