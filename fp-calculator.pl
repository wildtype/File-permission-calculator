#!/usr/bin/env perl

# Copyright (C) 2015 by Wildtype / Walang
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Convert file permission (rwxrwxrwx) into octal code (777)
# An attempt to learn Gtk3, glade, and perl
# Gtk3 documentation for perl are sucks (even not exist)
# Gtk's documentation in C and python comes as saviour

use strict;
use warnings;
use Gtk3 '-init';
use Pango;

my $interface = join '', <DATA>;
close DATA;

my $builder = Gtk3::Builder->new();
$builder->add_from_string($interface);
$builder->connect_signals(undef);

# w = Widgets
# get all widgets from gtkbuilder
my %w = get_objects (
    $builder, 
    qw{MainWindow dgHelp cbOwnerRead cbOwnerWrite cbOwnerExe cbGroupRead 
    cbGroupWrite cbGroupExe cbOtherRead cbOtherWrite cbOtherExe 
    tbOctal}
);

my $font = Pango::FontDescription->from_string("monospace 16");
$w{tbOctal}->modify_font($font);
$font->free();
$w{MainWindow}->show_all();

Gtk3->main();

sub on_MainWindow_delete_event
{
    Gtk3::main_quit();
}

sub on_cbs_toggled
{
    my $isOwnerRead = $w{cbOwnerRead}->get_active();
    my $isOwnerWrite = $w{cbOwnerWrite}->get_active();
    my $isOwnerExe = $w{cbOwnerExe}->get_active();
    my $isGroupWrite = $w{cbGroupWrite}->get_active();
    my $isGroupRead = $w{cbGroupRead}->get_active();
    my $isGroupExe = $w{cbGroupExe}->get_active();
    my $isOtherRead = $w{cbOtherRead}->get_active();
    my $isOtherWrite = $w{cbOtherWrite}->get_active();
    my $isOtherExe = $w{cbOtherExe}->get_active();
    my $umod = 4*$isOwnerRead + 2*$isOwnerWrite + 1*$isOwnerExe;
    my $gmod = 4*$isGroupRead + 2*$isGroupWrite + 1*$isGroupExe;
    my $omod = 4*$isOtherRead + 2*$isOtherWrite + 1*$isOtherExe;
    $w{tbOctal}->set_text($umod.$gmod.$omod);
}

sub on_tbOctal_changed
{
    my $octal = $w{tbOctal}->get_text();
    #proses cuma kalau nilainya 3digit oktal
    if ($octal =~ /^[0-7]{3}$/) {
        my @u = qw{Owner Group Other}; #u means user(s)
        my @m = qw{Read Write Exe}; # means mode(s)
        my @oct = split '',$octal;
        foreach my $i (0..2) {
            my $m_dec = $oct[$i]; # mode dalam desimal
            my @m_bin = split '',sprintf("%03b", $m_dec);
            foreach my $j (0..2) {
                my $key = "cb".$u[$i].$m[$j];
                $w{$key}->set_active($m_bin[$j]+0);
            }
        }

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

__DATA__

<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <!-- interface-requires gtk+ 3.0 -->
  <object class="GtkWindow" id="MainWindow">
    <property name="can_focus">False</property>
    <property name="title" translatable="yes">File Permission Calculator</property>
    <property name="resizable">False</property>
    <property name="has_resize_grip">False</property>
    <signal name="delete-event" handler="on_MainWindow_delete_event" swapped="no"/>
    <child>
      <object class="GtkBox" id="box1">
        <property name="visible">True</property>
        <property name="can_focus">False</property>
        <property name="orientation">vertical</property>
        <child>
          <object class="GtkGrid" id="grid1">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <child>
              <object class="GtkFrame" id="frameOwner">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="margin_left">5</property>
                <property name="margin_top">5</property>
                <property name="label_xalign">0</property>
                <property name="shadow_type">none</property>
                <child>
                  <object class="GtkAlignment" id="alignment2">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="left_padding">12</property>
                    <child>
                      <object class="GtkBox" id="box2">
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="orientation">vertical</property>
                        <child>
                          <object class="GtkCheckButton" id="cbOwnerRead">
                            <property name="label" translatable="yes">Read</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="xalign">0</property>
                            <property name="yalign">0.4699999988079071</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">0</property>
                          </packing>
                        </child>
                        <child>
                          <object class="GtkCheckButton" id="cbOwnerWrite">
                            <property name="label" translatable="yes">Write</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="xalign">0</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">1</property>
                          </packing>
                        </child>
                        <child>
                          <object class="GtkCheckButton" id="cbOwnerExe">
                            <property name="label" translatable="yes">Execute</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="xalign">0</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">2</property>
                          </packing>
                        </child>
                      </object>
                    </child>
                  </object>
                </child>
                <child type="label">
                  <object class="GtkLabel" id="labelOwner">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="label" translatable="yes">&lt;b&gt;Owner&lt;/b&gt;</property>
                    <property name="use_markup">True</property>
                  </object>
                </child>
              </object>
              <packing>
                <property name="left_attach">0</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
            <child>
              <object class="GtkFrame" id="frameGroup">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="margin_left">5</property>
                <property name="margin_right">5</property>
                <property name="margin_top">5</property>
                <property name="label_xalign">0</property>
                <property name="label_yalign">0.50999999046325684</property>
                <property name="shadow_type">none</property>
                <child>
                  <object class="GtkAlignment" id="alignment3">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="left_padding">12</property>
                    <child>
                      <object class="GtkBox" id="box3">
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="orientation">vertical</property>
                        <child>
                          <object class="GtkCheckButton" id="cbGroupRead">
                            <property name="label" translatable="yes">Read</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="relief">none</property>
                            <property name="xalign">0</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">0</property>
                          </packing>
                        </child>
                        <child>
                          <object class="GtkCheckButton" id="cbGroupWrite">
                            <property name="label" translatable="yes">Write</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="xalign">0</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">1</property>
                          </packing>
                        </child>
                        <child>
                          <object class="GtkCheckButton" id="cbGroupExe">
                            <property name="label" translatable="yes">Execute</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="xalign">0</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">2</property>
                          </packing>
                        </child>
                      </object>
                    </child>
                  </object>
                </child>
                <child type="label">
                  <object class="GtkLabel" id="labelGroup">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="label" translatable="yes">&lt;b&gt;Group&lt;/b&gt;</property>
                    <property name="use_markup">True</property>
                  </object>
                </child>
              </object>
              <packing>
                <property name="left_attach">1</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
            <child>
              <object class="GtkFrame" id="frameOther">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="margin_right">5</property>
                <property name="margin_top">5</property>
                <property name="label_xalign">0</property>
                <property name="shadow_type">none</property>
                <child>
                  <object class="GtkAlignment" id="alignment4">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="left_padding">12</property>
                    <child>
                      <object class="GtkBox" id="box4">
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="orientation">vertical</property>
                        <child>
                          <object class="GtkCheckButton" id="cbOtherRead">
                            <property name="label" translatable="yes">Read</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="xalign">0</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">0</property>
                          </packing>
                        </child>
                        <child>
                          <object class="GtkCheckButton" id="cbOtherWrite">
                            <property name="label" translatable="yes">Write</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="xalign">0</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">1</property>
                          </packing>
                        </child>
                        <child>
                          <object class="GtkCheckButton" id="cbOtherExe">
                            <property name="label" translatable="yes">Execute</property>
                            <property name="use_action_appearance">False</property>
                            <property name="visible">True</property>
                            <property name="can_focus">True</property>
                            <property name="receives_default">False</property>
                            <property name="use_action_appearance">False</property>
                            <property name="xalign">0</property>
                            <property name="draw_indicator">True</property>
                            <signal name="toggled" handler="on_cbs_toggled" swapped="no"/>
                          </object>
                          <packing>
                            <property name="expand">False</property>
                            <property name="fill">True</property>
                            <property name="position">2</property>
                          </packing>
                        </child>
                      </object>
                    </child>
                  </object>
                </child>
                <child type="label">
                  <object class="GtkLabel" id="labelOther">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="label" translatable="yes">&lt;b&gt;Other&lt;/b&gt;</property>
                    <property name="use_markup">True</property>
                  </object>
                </child>
              </object>
              <packing>
                <property name="left_attach">2</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">0</property>
          </packing>
        </child>
        <child>
          <object class="GtkAlignment" id="alignment1">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <child>
              <object class="GtkEntry" id="tbOctal">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="margin_left">5</property>
                <property name="margin_right">5</property>
                <property name="margin_top">5</property>
                <property name="margin_bottom">5</property>
                <property name="max_length">3</property>
                <property name="invisible_char">●</property>
                <property name="text" translatable="yes">000</property>
                <property name="xalign">0.5</property>
                <signal name="changed" handler="on_tbOctal_changed" swapped="no"/>
              </object>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">1</property>
          </packing>
        </child>
        <child>
          <object class="GtkBox" id="box5">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <property name="orientation">vertical</property>
            <child>
              <object class="GtkAlignment" id="alignment5">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="top_padding">2</property>
                <property name="bottom_padding">3</property>
                <property name="left_padding">4</property>
                <property name="right_padding">5</property>
                <child>
                  <object class="GtkTextView" id="textview1">
                    <property name="visible">True</property>
                    <property name="can_focus">True</property>
                    <property name="vscroll_policy">natural</property>
                    <property name="editable">False</property>
                    <property name="wrap_mode">word</property>
                    <property name="justification">center</property>
                    <property name="buffer">textbuffer1</property>
                  </object>
                </child>
              </object>
              <packing>
                <property name="expand">False</property>
                <property name="fill">True</property>
                <property name="position">0</property>
              </packing>
            </child>
            <child>
              <object class="GtkButton" id="btExit">
                <property name="label">gtk-quit</property>
                <property name="use_action_appearance">False</property>
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="receives_default">True</property>
                <property name="margin_left">5</property>
                <property name="margin_right">5</property>
                <property name="margin_bottom">5</property>
                <property name="use_action_appearance">False</property>
                <property name="use_stock">True</property>
                <signal name="clicked" handler="on_MainWindow_delete_event" swapped="no"/>
              </object>
              <packing>
                <property name="expand">True</property>
                <property name="fill">True</property>
                <property name="position">1</property>
              </packing>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">2</property>
          </packing>
        </child>
      </object>
    </child>
  </object>
  <object class="GtkAdjustment" id="adjustment1">
    <property name="upper">100</property>
    <property name="step_increment">1</property>
    <property name="page_increment">10</property>
  </object>
  <object class="GtkTextBuffer" id="textbuffer1">
    <property name="text" translatable="yes">Click on checkboxes or edit the textbox to convert file permission into octal code and vice versa.</property>
  </object>
</interface>
