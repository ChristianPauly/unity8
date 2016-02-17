/*
 * Copyright (C) 2016 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Unity.Application 0.1

Item {
    property bool active: true
    property QtObject application: null

    QtObject {
        id: priv
        property var lastSurface: application && application.session ?
                                  application.session.lastSurface : null
        onLastSurfaceChanged: {
            if (!active || !lastSurface) return;
            if (lastSurface.shellChrome === Mir.LowChrome) {
                lastSurface.state = Mir.FullscreenState;
            }
        }
    }

    Connections {
        target: priv.lastSurface
        onShellChromeChanged: {
            if (!active || !priv.lastSurface) return;
            if (priv.lastSurface.shellChrome === Mir.LowChrome || priv.lastSurface.state == Mir.FullscreenState) {
                priv.lastSurface.state = Mir.FullscreenState;
            } else {
                priv.lastSurface.state = Mir.RestoredState;
            }
        }
        onStateChanged: {
            if (!active) return;
            if (priv.lastSurface.state === Mir.RestoredState && priv.lastSurface.shellChrome === Mir.LowChrome) {
                priv.lastSurface.state = Mir.FullscreenState;
            }
        }
    }
}

