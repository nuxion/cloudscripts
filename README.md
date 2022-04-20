# CloudScripts

This is a collections of different scripts used for software and server provisioning in the context of cloud, usually docker, some networking configurations and so forth. 

I used to use ansible in a push strategy approach (from client or bastion to servers), however with the introduction of different HashiCorp tools, this strategy started to be cumbersome. Instead, I would like that each server execute by their self the related scripts using environment knowledge provided by the cloud platform like Metadata server, labels & tags, in a pull strategy approach.

For the time being, this runs over GCE cloud, but should be easy to adapt for other providers, besides some scripts are agnostics. Let me know if you are interest in other providers, or tools. 

A terraform sandbox is included for testing purposes. 

Tools used:
- Shell scripts
- Gomplate for templating

## Inspirations
- https://www.serf.io/docs/recipes/event-handler-router.html
- https://github.com/void-linux/void-infrastructure
 




