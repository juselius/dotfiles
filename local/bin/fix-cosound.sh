#!/bin/sh

card=$(pacmd list-cards | sed -n 's/index://p' |tail -1)

set -x
pacmd set-card-profile $card a2dp_sink_aac

