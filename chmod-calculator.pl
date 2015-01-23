#!/usr/bin/env perl

use strict;
use warnings;
use Gtk3 '-init';

my $builder = Gtk3::Builder->new();
$builder->add_from_file("interface.ui");
$builder->connect_signals(undef);

my $window = $builder->get_object("MainWindow");
$window->show_all();

#get all necessary objects
my $cbUserRead = $builder->get_object("cbUserRead");
my $cbUserWrite = $builder->get_object("cbUserWrite");
my $tbOctal = $builder->get_object("tbOctal");

Gtk3->main();

sub on_MainWindow_delete_event
{
    Gtk3::main_quit();
}

sub on_cbs_toggled
{
    my $isUserRead = $cbUserRead->get_active();
    if($isUserRead) {
        $tbOctal->set_text("User can read file");
    } else {
        $tbOctal->set_text("User can't read file");
    }
}
