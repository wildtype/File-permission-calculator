#!/usr/bin/env perl

use strict;
use warnings;
use Gtk3 '-init';

my $builder = Gtk3::Builder->new();
$builder->add_from_file("interface.ui");
$builder->connect_signals(undef);
my $window = $builder->get_object("MainWindow");
$window->show_all();
Gtk3->main();

sub on_MainWindow_delete_event
{
    Gtk3::main_quit;
}
