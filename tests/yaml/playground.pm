use strict;
use warnings;
use base "basetest";
use testapi;
use utils;

my $url = "https://play.yaml.io/main/parser";

sub run {
    send_key "ctrl-alt-f3";
    assert_screen "inst-console";
    type_string "root\n";
    assert_screen "password-prompt";
    $testapi::password = 'nots3cr3t';
    type_string $testapi::password . "\n";
    wait_still_screen(2);
    diag('Ensure packagekit is not interfering with zypper calls');
    assert_script_run('systemctl mask --now packagekit');

    my @packages = qw( docker );
    assert_script_run("zypper -n in @packages", timeout => 600);
    assert_script_run "systemctl start docker";
    enter_cmd "exit";

    demosleep 1;
    switch_to_x11;
    demosleep 1;
    ensure_unlocked_desktop();
    demosleep 2;
    x11_start_program("xterm", 60, {valid => 1});
    demosleep 4;
    type_string "which firefox\n";
    type_string "firefox $url &\n";
    demosleep 1;
    assert_screen 'ff-playgound-start', 50;
    demosleep 2;

    send_key 'ctrl-a';
    demosleep 2;
    send_key 'delete';
    demosleep 2;
    type_string "---\nopenQA: rocks!";

    assert_and_click 'ff-playgound-enter-example', timeout => 10;

    assert_screen 'ff-run-docker-hint';
    demosleep 2;
    assert_and_dclick 'ff-run-docker-hint-match-command', timeout => 10;
    send_key 'alt-tab';
    assert_screen 'xterm-prompt', 10;
    enter_cmd "sudo docker run --rm -p 31337:31337 -d yamlio/yaml-play-sandbox:0.1.32 31337";
    demosleep 2;
    type_string $testapi::password . "\n";
    assert_screen "ff-playground-docker-started", 40;
    demosleep 2;
    send_key 'alt-tab';

    demosleep 2;
    assert_and_click 'ff-run-docker-hint-match-link', timeout => 10;

    demosleep 4;
    assert_and_click 'ff-playgound-local-cert-error', timeout => 10;

    assert_screen 'ff-playgound-local-cert-error-advanced', 10;
    demosleep 1;
    send_key 'end';
    demosleep 1;
    assert_and_click 'ff-playgound-local-cert-error-advanced-scrolled-down', timeout => 10;

    assert_and_click 'ff-playgound-local-cert-error-advanced-accept-risk', timeout => 10;

    demosleep 1;
    assert_and_click 'ff-run-docker-hint';
    demosleep 5;
    assert_screen 'ff-playgound-start-with-docker', 10;
    demosleep 5;
    send_key 'down';
    send_key 'down';
    send_key 'down';
    demosleep 1;
    send_key 'ret';

    type_string "break it!";
    demosleep 7;
    send_key 'home';
    demosleep 1;
    type_string '# ';

    demosleep 5;
    assert_and_click 'ff-playgound-enter-example-with-docker', timeout => 10;
}

1;
