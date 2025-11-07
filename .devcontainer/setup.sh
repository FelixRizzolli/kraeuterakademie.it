#!/bin/bash

mkdir -p /root/.ssh
cp -p /root/local-ssh/* /root/.ssh/

chmod 700 /root/.ssh
chmod 600 /root/.ssh/*
chmod 644 /root/.ssh/*.pub
chown -R root:root /root/.ssh