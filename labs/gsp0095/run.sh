#!/bin/bash

set -eux

# --------------------------------
# Create topic
# --------------------------------
TOPIC_1="myTopic"
TOPIC_2="Test1"
TOPIC_3="Test2"

gcloud pubsub topics create $TOPIC_1
gcloud pubsub topics create $TOPIC_2
gcloud pubsub topics create $TOPIC_3

gcloud pubsub topics list

gcloud pubsub topics delete $TOPIC_2
gcloud pubsub topics delete $TOPIC_3

gcloud pubsub topics list

# --------------------------------
# Create subscription
# --------------------------------
SUBSCRIPTION_1="mySubscription"
SUBSCRIPTION_2="Test1"
SUBSCRIPTION_3="Test2"

gcloud pubsub subscriptions create --topic $TOPIC_1 $SUBSCRIPTION_1
gcloud pubsub subscriptions create --topic $TOPIC_1 $SUBSCRIPTION_2
gcloud pubsub subscriptions create --topic $TOPIC_1 $SUBSCRIPTION_3

gcloud pubsub topics list-subscriptions $TOPIC_1

gcloud pubsub subscriptions delete $SUBSCRIPTION_2
gcloud pubsub subscriptions delete $SUBSCRIPTION_3

gcloud pubsub topics list-subscriptions $TOPIC_1

# --------------------------------
# Create and pull messages
# --------------------------------
gcloud pubsub topics publish $TOPIC_1 --message "Hello"
gcloud pubsub topics publish $TOPIC_1 --message "World"
gcloud pubsub topics publish $TOPIC_1 --message "!!"

gcloud pubsub subscriptions pull $SUBSCRIPTION_1 --auto-ack
gcloud pubsub subscriptions pull $SUBSCRIPTION_1 --auto-ack
gcloud pubsub subscriptions pull $SUBSCRIPTION_1 --auto-ack
gcloud pubsub subscriptions pull $SUBSCRIPTION_1 --auto-ack

gcloud pubsub topics publish $TOPIC_1 --message "Hello"
gcloud pubsub topics publish $TOPIC_1 --message "World"
gcloud pubsub topics publish $TOPIC_1 --message "!!"

gcloud pubsub subscriptions pull $SUBSCRIPTION_1 --limit 3
