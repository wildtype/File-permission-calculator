#!/usr/bin/env perl

use strict;
use warnings;
use Gtk3 '-init';

my $builder = Gtk3::Builder->new();
$builder->add_from_file("interface-btn.glade");
$builder->connect_signals(destroy=>sub{Gtk3::main_quit;});
my $window = $builder->get_object("MainWindow");
$window->show_all();
Gtk3->main();

exit;
