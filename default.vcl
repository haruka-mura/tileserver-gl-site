vcl 4.0;

import directors;

probe basic {
  .url = "/";
  .timeout = 1s;
  .interval = 10s;
  .window = 5;
  .threshold = 3;
}

backend tile {
  .host = "tile";
  .port = "8080";
  .probe = basic;
}

sub vcl_init {
  new bar = directors.round_robin();
  bar.add_backend(tile);
}

sub vcl_recv {
  # send all traffic to the bar director:
  set req.backend_hint = bar.backend();
  return (hash);
}

sub vcl_deliver {
  return (deliver);
}

sub vcl_backend_response {
  set beresp.ttl = 2h;
}
