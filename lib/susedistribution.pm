package susedistribution;
use base 'distribution';

# Base class for all test modules

use testapi qw(get_var send_key assert_screen check_screen save_screenshot type_string mouse_hide);

sub x11_start_program {
    my ($self, $program, $timeout, $options) = @_;
    send_key 'alt-f2';
    mouse_hide(1);
    assert_screen('desktop-runner', $timeout);
#    type_string $program, get_var('DEMO_MODE') ? (max_interval => 20) : ();
    type_string $program;
    if ($options->{terminal}) {
        wait_screen_change { send_key 'alt-t' };
    }
    save_screenshot;
    bmwqemu::diag("!!!!!!!!!!!!!!!!!!!!!!");
    send_key 'ret';
    # make sure desktop runner executed and closed when have had valid value
    # exec x11_start_program( $program, $timeout, { valid => 1 } );
    if ($options->{valid}) {
        foreach my $i (1 .. 3) {
            bmwqemu::diag("i=$i");
            last unless check_screen 'desktop-runner-border', 2;
            send_key 'ret';
        }
    }
}

1;
