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

namespace RegexTester.Widgets {
    public class MatchItem : Gtk.ListBoxRow {

        public int start { get; set; }
        public int end { get; set; }

        public MatchItem (int count, string text, int start, int end) {
            this.start = start;
            this.end = end;
            var content = new Gtk.Grid ();
            content.margin = 6;
            content.row_spacing = 6;

            var match_count = new Gtk.Label (_("Match %d").printf (count));
            match_count.hexpand = true;
            match_count.halign = Gtk.Align.START;

            var match_text = new Gtk.Label (text);
            match_text.tooltip_text = text;
            match_text.ellipsize = Pango.EllipsizeMode.MIDDLE;
            match_text.hexpand = true;
            match_text.halign = Gtk.Align.START;

            string pkgdir = Constants.PKGDATADIR;

            Gtk.Image icon;
            if (count % 2 == 0) {
                icon = new Gtk.Image.from_file(pkgdir + "/icons/regex_match_second.svg");
            } else {
                icon = new Gtk.Image.from_file(pkgdir + "/icons/regex_match_first.svg");
            }
            var pos = new Gtk.Label (("<span font_size=\"small\">%d - %d</span>").printf (start, end));
            pos.use_markup = true;
            pos.halign = Gtk.Align.END;

            content.attach (icon, 0, 0);
            content.attach (match_count, 1, 0);
            content.attach (pos, 2, 0);
            content.attach (match_text, 0, 1, 3, 1);
            this.add (content);
        }
    }
}

