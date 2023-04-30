#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

my $api_endpoint = 'http://<IP>:<PORT>/submit_pfb';

get '/' => 'index';

post '/submit' => sub ($c) {
  my $namespace_id = $c->param('namespace_id');
  my $data = $c->param('data');

  my $ua = Mojo::UserAgent->new;
  my $tx = $ua->post(
    $api_endpoint => json => {
      namespace_id => $namespace_id,
      data         => $data,
      gas_limit    => 80000,
      fee          => 2000
    }
  );

  if (my $res = $tx->success) {
    #$c->render(text => 'Transaction submitted successfully!');
        my $json_response = $res->body;
        $c->render(text => "Transaction submitted successfully! Response: \n $json_response");
  }
  else {
    my ($error, $code) = $tx->error;
    $c->render(text => "Error: $error ($code)");
  }
};

#app->start;
app->start('daemon', '-l', 'http://*:3000');

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Celestia pfb  Transaction</title>
        <style>
                body {
                  font-family: verdana;
                }
        </style>
  </head>
  <body>
        <image src="https://pbs.twimg.com/profile_images/1404854187721203715/zZp1s7c3_400x400.jpg" width=200px></image>
        <h1>Celestia PFB Submit Transaction</h1>
        <h2>by: SATMan</h2>
        <h2>NodeID: 12D3KooWARYrY8eZFZx3BwsUNbXDiddXDNN3a2PgHPcLh2cPwusc</h2>
    <form action="/submit" method="post">
      <label for="namespace_id">Namespace ID:</label>
      <input type="text" id="namespace_id" name="namespace_id" required>
      <br><br>
      <label for="data">Data:</label>
      <input type="text" id="data" name="data" required>
      <br><br>
      <button type="submit">Submit</button>
    </form>
  </body>
</html>
