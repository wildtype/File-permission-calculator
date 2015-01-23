#!/usr/bin/env perl

use strict;
use warnings;
use Gtk3 '-init';

my $builder = Gtk3::Builder->new();
$builder->add_from_file("interface.ui");
$builder->connect_signals(undef);

my %w = get_objects($builder, qw{MainWindow cbUserRead cbUserWrite tbOctal});
$w{MainWindow}->show_all();

Gtk3->main();

sub on_MainWindow_delete_event
{
    Gtk3::main_quit();
}

sub on_cbs_toggled
{
    my $isUserRead = $w{cbUserRead}->get_active();
    if($isUserRead) {
        $w{tbOctal}->set_text("User can read file");
    } else {
        $w{tbOctal}->set_text("User can't read file");
    }
}

# ambil semua objek dari gtkbuilder/glade
# pengganti Gtk::Builder->get_object untuk tiap2 object
# panggil sekali, dapat semua, macam itulah
# return hash dengan key berupa nama object
sub get_objects
{
    my $builder = shift;
    my %objects;
    foreach my $object_name (@_) {
        my $object = $builder->get_object($object_name);
        $objects{$object_name} = $object;
    }
    return %objects;
}
