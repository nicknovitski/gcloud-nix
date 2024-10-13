# Options

These are the options currently declared by `gcloud-nix`.

## Basic options

### `gcloud.enable`

If true, the Google Cloud SDK and any defined `extra-components` are added to the environment.

Default value: false

### `gcloud.extra-components`

An array of IDs of SDK components to add to the environment, if `gcloud.enable` is true.  Run `gcloud components list` to see the list of available components and their IDs. 

Default value: `[]`

## Configuration options

These options deal with *named configurations*.  For more information, run `gcloud topics configuration`.

### `gcloud.properties`

An attribute set of attribute sets, whose values are either non-empty strings, `true`, or `false`.  Each nested attribute represents a configuration property to set in the enironment, with the top-level attribute names being the section.

For example, the option declaration `gcloud.properties.core.project = "myproject";` will add the environment variable `CLOUDSDK_CORE_PROJECT=myproject` to the environment, causing the property `core/project` to be set to `myproject` for all commands, while the declaration `gcloud.properties.context-aware.use-client-certificate = true;` will create the variable `CLOUDSDK_CONTEXT_AWARE_USE_CLIENT_CERTIFICATE=1` which will set the property `context_aware/use_client_certificate` to `True`.

NOTE: section and property names may include the underscore character `_`.  Corresponding option names may instead use include the dash character `-`.

Default value: empty

### `gcloud.config-directory`

A non-empty string representing the path to the directory in which to store configuration for the Google Cloud SDK's when it is invoked in the environment.  If the option is defined, the environment variable `CLOUDSDK_CONFIG` is defined in the environment with the same value.

If no directory exists at that path, it will be created.  If the directory exists but the user does not have write permissions on it, the Google Cloud SDK may not work correctly.

Default value: not defined

### `gcloud.active-configuration-name`

A non-empty string representing the name of the configuration to use in the environment.

Default value: not defined
