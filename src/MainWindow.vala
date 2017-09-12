/*-
 * Copyright (c) 2017-2017 Artem Anufrij <artem.anufrij@live.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * The Noise authors hereby grant permission for non-GPL compatible
 * GStreamer plugins to be used and distributed together with GStreamer
 * and Noise. This permission is above and beyond the permissions granted
 * by the GPL license by which Noise is covered. If you modify this code
 * you may extend this exception to your version of the code, but you are not
 * obligated to do so. If you do not wish to do so, delete this exception
 * statement from your version.
 *
 * Authored by: Artem Anufrij <artem.anufrij@live.de>
 */

namespace RegexTester {

    public class MainWindow : Gtk.Window {

        public signal void match (int count, GLib.List<RegexTester.GroupItem> group_items);

        Gtk.Grid sidebar;
        Gtk.ListBox matches;
        Gtk.Entry entry;
        Gtk.TextView result;
        Gtk.ScrolledWindow result_scroll;
        Gtk.HeaderBar headerbar;
        Gtk.Switch multiline;

        Gtk.ComboBoxText style_chooser;

        Settings settings;

        uint typing_timer = 0;

        public MainWindow () {
            settings = Settings.get_default ();
            this.width_request = settings.window_width;
            this.height_request = settings.window_height;

            this.match.connect ((count, group_items) => {
                this.matches.add (new Widgets.MatchItem (count, group_items));
                this.matches.show_all ();
            });

            this.destroy.connect (() => {
                settings.window_width = this.width_request;
                settings.window_height = this.height_request;
                settings.sidebar_visible = this.sidebar.visible;
                settings.multiline = this.multiline.active;
                settings.regex_style = this.style_chooser.active_id;
            });

            build_ui ();

            present ();
        }

        private void build_ui () {
            headerbar = new Gtk.HeaderBar ();
            headerbar.title = _("Regex Tester");
            headerbar.show_close_button = true;

            var show_sidebar = new Gtk.Button.from_icon_name ("pane-show-symbolic-rtl", Gtk.IconSize.LARGE_TOOLBAR);
            show_sidebar.clicked.connect (() => {
                sidebar.visible = !sidebar.visible;
            });
            headerbar.pack_end (show_sidebar);
            this.set_titlebar (headerbar);

            var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

            var content = new Gtk.Grid ();

            entry = new Gtk.Entry ();
            entry.margin = 12;
            entry.placeholder_text = _("Regular expression");
            entry.changed.connect (check_regex);
            content.attach (entry, 0, 0);

            var result_label = new Gtk.Label ("<b>%s</b>".printf("Test String"));
            result_label.use_markup = true;
            result_label.margin = 6;
            result_label.margin_left = 12;
            result_label.halign = Gtk.Align.START;
            content.attach (result_label, 0, 1);

            var separator_result = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            separator_result.hexpand = true;
            content.attach (separator_result, 0, 2);

            result = new Gtk.TextView ();
            result.top_margin = result.left_margin = result.bottom_margin = result.right_margin = 12;
            result.wrap_mode = Gtk.WrapMode.WORD;

            result.buffer.create_tag ("marked_first", "background", "#8cd5ff");
            result.buffer.create_tag ("marked_second", "background", "#d1ff82");
            result.buffer.create_tag ("marked_sub_0", "background", "#abacae");
            result.buffer.create_tag ("marked_sub_1", "background", "#ff8c82");
            result.buffer.create_tag ("marked_sub_2", "background", "#f9c440");
            result.buffer.create_tag ("marked_sub_3", "background", "#95a3ab");
            result.buffer.create_tag ("marked_sub_4", "background", "#e29ffc");
            result.buffer.create_tag ("marked_highlight", "background", "#ffa154");
            result.buffer.changed.connect (check_regex);

            result_scroll = new Gtk.ScrolledWindow (null, null);
            result_scroll.expand = true;
            result_scroll.add (result);

            content.attach (result_scroll, 0, 3);

            sidebar = new Gtk.Grid ();
            sidebar.width_request = 120;
            sidebar.notify["visible"].connect (() => {
                if (sidebar.visible) {
                    show_sidebar.image = new Gtk.Image.from_icon_name ("pane-hide-symbolic-rtl", Gtk.IconSize.LARGE_TOOLBAR);
                    show_sidebar.tooltip_text = _("Hide Sidebar");
                } else {
                    show_sidebar.image = new Gtk.Image.from_icon_name ("pane-show-symbolic-rtl", Gtk.IconSize.LARGE_TOOLBAR);
                    show_sidebar.tooltip_text = _("Show Sidebar");
                }
            });

            var options = new Gtk.Grid ();
            options.margin = 12;
            options.column_spacing = 12;
            options.row_spacing = 12;
            sidebar.attach (options, 0, 0);

            var multiline_title = new Gtk.Label (_("Multiline"));
            multiline_title.halign = Gtk.Align.END;
            options.attach (multiline_title, 0, 0);

            multiline = new Gtk.Switch ();
            multiline.halign = Gtk.Align.START;
            multiline.active = settings.multiline;
            multiline.notify["active"].connect (check_regex);
            options.attach (multiline, 1, 0);

            var js_compat_title = new Gtk.Label (_("Regex Style"));
            js_compat_title.halign = Gtk.Align.END;
            options.attach (js_compat_title, 0, 1);

            style_chooser = new Gtk.ComboBoxText ();
            style_chooser.append ("Javascript", "Javascript");
            style_chooser.append ("Perl", "Perl");
            style_chooser.active_id = settings.regex_style;
            style_chooser.tooltip_text = _("Choose a Regex Style");
            style_chooser.changed.connect (check_regex);
            options.attach (style_chooser, 1, 1);

            var matches_label = new Gtk.Label ("<b>%s</b>".printf(_("Match Information")));
            matches_label.halign = Gtk.Align.START;
            matches_label.use_markup = true;
            matches_label.margin = 6;
            sidebar.attach (matches_label, 0, 2, 2, 1);

            var separator_matches = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            separator_matches.hexpand = true;
            sidebar.attach (separator_matches, 0, 3, 2, 1);

            var scroller = new Gtk.ScrolledWindow (null, null);

            matches = new Gtk.ListBox ();
            matches.expand = true;
            matches.selected_rows_changed.connect (() => {
                var item = this.matches.get_selected_row () as Widgets.MatchItem;
                if (item != null) {
                    this.set_selected_match (item.start, item.end);
                }
            });
            scroller.add (matches);
            sidebar.attach (scroller, 0, 4, 2, 1);

            paned.pack1 (content, true, false);
            paned.pack2 (sidebar, false, false);

            this.add (paned);
            this.show_all ();

            result.grab_focus ();
            sidebar.visible = settings.sidebar_visible;
        }

        private void check_regex () {

            if (typing_timer != 0) {
                Source.remove (typing_timer);
            }

            typing_timer = GLib.Timeout.add (300, () => {
                var regex = this.entry.text;
                entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, null);

                var buffer = result.buffer;
                var text = buffer.text;

                foreach (var child in matches.get_children ()) {
                    matches.remove (child);
                }

                Gtk.TextIter s, e;
                buffer.get_bounds (out s, out e);

                reset_tags (buffer);

                if (regex == "") {
                    typing_timer = 0;
                    return false;
                }

                try {
                    RegexCompileFlags flags = RegexCompileFlags.JAVASCRIPT_COMPAT;
                    if (multiline.active) {
                        flags |= RegexCompileFlags.MULTILINE;
                    }
                    if (style_chooser.active_id == "Javascript") {
                        flags |= RegexCompileFlags.JAVASCRIPT_COMPAT;
                    }

                    var reg = new Regex (regex, flags);
                    MatchInfo mi;

                    if (reg.match(text, 0 , out mi)) {
                        bool mod = true;
                        int count = 1;

                        int pos_start = 0;
                        int pos_end = 0;
                        do {
                            GLib.List<RegexTester.GroupItem> group_items = new GLib.List<RegexTester.GroupItem> ();

                            for (int i = 0; i < mi.get_match_count (); i++) {
                                mi.fetch_pos (i, out pos_start, out pos_end);
                                if (pos_start == pos_end) {
                                    continue;
                                }

                                int offset_start = pos_start - shift_unichar (text, pos_start);
                                int offset_end = pos_end - shift_unichar (text, pos_end);

                                s.set_offset (offset_start);
                                e.set_offset (offset_end);

                                if (i == 0) {
                                    if (mod) {
                                        buffer.apply_tag_by_name ("marked_first", s, e);
                                    } else {
                                        buffer.apply_tag_by_name ("marked_second", s, e);
                                    }
                                    mod = !mod;
                                } else {
                                    var sub_mod = "marked_sub_" + (i % 5).to_string ();
                                    buffer.apply_tag_by_name (sub_mod, s, e);
                                }
                                string str = mi.fetch (i);

                                var new_group_item = new RegexTester.GroupItem (str, offset_start, offset_end);
                                group_items.append (new_group_item);
                            }
                            match (count, group_items);
                            count ++;
                        } while (mi.next ());
                    }
                } catch (Error e) {
                    warning (e.message);
                    entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "process-error");
                    entry.set_icon_tooltip_text (Gtk.EntryIconPosition.SECONDARY, e.message);
                }
                typing_timer = 0;
                return false;
            });
        }

        private void set_selected_match (int start, int end) {
            var text = this.result.buffer.text;
            Gtk.TextIter s, e;
            this.result.buffer.get_bounds (out s, out e);

            s.set_offset (0);
            e.set_offset (text.length);

            this.result.buffer.remove_tag_by_name ("marked_highlight", s, e);

            s.set_offset (start);
            e.set_offset (end);
            this.result.buffer.apply_tag_by_name ("marked_highlight", s, e);
            this.result.scroll_to_iter (s, 0, false, 0, 0);
        }

        private void reset_tags (Gtk.TextBuffer buffer) {
            var text = buffer.text;
            Gtk.TextIter s, e;
            buffer.get_bounds (out s, out e);

            s.set_offset (0);
            e.set_offset (text.length);

            buffer.remove_all_tags (s, e);
        }

        private int shift_unichar (string text, int pos){
            int return_value = 0;
            var substring = text.substring (0, pos);

            foreach (var c in substring.to_utf8 ()) {
                if (c.isprint () || c.isspace ()) {
                    continue;
                }
                return_value += 1;
            }

            return return_value / 2;
        }
    }
}
