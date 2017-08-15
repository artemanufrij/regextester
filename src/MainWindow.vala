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

        public MainWindow () {
            this.title = _("Regex Tester");
            this.resizable = false;

            build_ui ();

            present ();
        }

        private void build_ui () {
            var content = new Gtk.Grid ();
            content.margin = 12;
            content.row_spacing = 12;

            entry = new Gtk.Entry ();
            entry.placeholder_text = _("Put your RegEx here…");
            entry.changed.connect (check_regex);
            content.attach (entry, 0, 0);

            result = new Gtk.TextView ();
            result.wrap_mode = Gtk.WrapMode.WORD;
            result.width_request = 640;
            result.height_request = 480;
            result.buffer.create_tag ("marked_first", "background", "#64baff");
            result.buffer.create_tag ("marked_second", "background", "#9bdb4d");
            result.buffer.changed.connect (check_regex);

            content.attach (result, 0, 1);
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
                var reg = new Regex (regex);
                MatchInfo mi;
                bool mod = true;

                if (reg.match(text, 0, out mi)) {
                    int pos_start = 0;
                    int pos_end = 0;
                    do{
                        mi.fetch_pos (0, out pos_start, out pos_end);
                        s.set_offset (pos_start);
                        e.set_offset (pos_end);
                        debug ("%s, %d, %d", mi.fetch (0), pos_start, pos_end);

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
    }
}
