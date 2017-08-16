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

        Gtk.Entry entry;
        Gtk.TextView result;
        Gtk.ScrolledWindow result_scroll;
        Gtk.HeaderBar headerbar;
        Gtk.CheckButton multiline;

        public MainWindow () {
            this.width_request = 720;
            this.height_request = 640;
            build_ui ();

            present ();
        }

        private void build_ui () {
            headerbar = new Gtk.HeaderBar ();
            headerbar.title = _("Regex Tester");
            headerbar.show_close_button = true;

            this.set_titlebar (headerbar);

            var content = new Gtk.Grid ();
            content.margin = 12;
            content.row_spacing = 12;

            multiline = new Gtk.CheckButton.with_label (_("Multiline"));
            multiline.toggled.connect (check_regex);

            var options = new Gtk.Grid ();
            options.column_homogeneous = true;
            options.attach (multiline, 0, 0);
            options.halign = Gtk.Align.CENTER;
            content.attach (options, 0, 1);

            entry = new Gtk.Entry ();
            entry.placeholder_text = _("Put your RegEx here…");
            entry.changed.connect (check_regex);
            content.attach (entry, 0, 0);

            result = new Gtk.TextView ();
            result.wrap_mode = Gtk.WrapMode.WORD;

            result.buffer.create_tag ("marked_first", "background", "#64baff");
            result.buffer.create_tag ("marked_second", "background", "#9bdb4d");
            result.buffer.changed.connect (check_regex);

            result_scroll = new Gtk.ScrolledWindow (null, null);
            result_scroll.expand = true;
            result_scroll.add (result);

            content.attach (result_scroll, 0, 2);
            this.add (content);
            this.show_all ();

            result.grab_focus ();
        }

        private void check_regex () {
            var regex = this.entry.text;

            var buffer = result.buffer;
            var text = buffer.text;

            Gtk.TextIter s, e;
            buffer.get_bounds (out s, out e);

            reset_tags (buffer);

            if (regex == "") {
                return;
            }

            try {
                RegexCompileFlags flags = RegexCompileFlags.JAVASCRIPT_COMPAT ;
                if (multiline.active) {
                    flags |= RegexCompileFlags.MULTILINE;
                }

                var reg = new Regex (regex, flags);
                MatchInfo mi;
                bool mod = true;

                if (reg.match(text, 0 , out mi)) {
                    int pos_start = 0;
                    int pos_end = 0;
                    do{
                        mi.fetch_pos (0, out pos_start, out pos_end);
                        s.set_offset (pos_start - shift_unichar (text, pos_start));
                        e.set_offset (pos_end - shift_unichar (text, pos_end));

                        string str = mi.fetch (0);

                        debug ("'%s' len (%d), %d, %d", str, str.length, pos_start, pos_end);

                        if (mod) {
                            buffer.apply_tag_by_name ("marked_first", s, e);
                        } else {
                            buffer.apply_tag_by_name ("marked_second", s, e);
                        }
                        mod = !mod;

                    } while (mi.next ());
                }
            } catch (Error e) {
                warning (e.message);
            }
        }

        private void reset_tags (Gtk.TextBuffer buffer) {
            var text = buffer.text;
            Gtk.TextIter s, e;
            buffer.get_bounds (out s, out e);

            s.set_offset (0);
            e.set_offset (text.length);

            buffer.remove_tag_by_name ("marked_first", s, e);
            buffer.remove_tag_by_name ("marked_second", s, e);
        }

        private int shift_unichar (string text, int pos){
            // FIXME: we need a better method. unichars have a length of 2 per character
            unichar [] black_list = {'«', '»'};
            int return_value = 0;

            foreach (var c in black_list) {
                int cur_pos = -1;
                do {
                    cur_pos = text.index_of_char (c, cur_pos + 1);
                    debug ("%d", cur_pos);
                    if (cur_pos > -1 && cur_pos < pos){
                        return_value += 1;
                    }
                } while (cur_pos > -1 && cur_pos < pos);
            }
            return return_value;
        }
    }
}
