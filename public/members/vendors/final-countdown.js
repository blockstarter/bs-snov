!function (e) {
    function o() {
        e(window).load(s), e(window).on("redraw", function () {
            switched = !1, s()
        }), e(window).on("resize", s)
    }

    function s() {
        w.draw(), v.draw(), b.draw(), f.draw()
    }

    function r(e) {
        return Math.PI / 180 * e - Math.PI / 180 * 90
    }

    function t() {
        i = {
            total: Math.floor((d.end - d.start) / 86400),
            days: Math.floor((d.end - d.now) / 86400),
            hours: 24 - Math.floor((d.end - d.now) % 86400 / 3600),
            minutes: 60 - Math.floor((d.end - d.now) % 86400 % 3600 / 60),
            seconds: 60 - Math.floor((d.end - d.now) % 86400 % 3600 % 60)
        }
    }

    function n() {
        var o = e("#" + d.selectors.canvas_seconds).width(), s = new Kinetic.Stage({
            container: d.selectors.canvas_seconds,
            width: o,
            height: o
        });
        c = new Kinetic.Shape({
            drawFunc: function (o) {
                var s = e("#" + d.selectors.canvas_seconds).width(), t = s / 2 - d.seconds.borderWidth / 2, n = s / 2, a = s / 2;
                o.beginPath(), o.arc(n, a, t, r(0), r(6 * i.seconds)), o.fillStrokeShape(this), e(d.selectors.value_seconds).html(60 - i.seconds)
            }, stroke: d.seconds.borderColor, strokeWidth: d.seconds.borderWidth
        }), w = new Kinetic.Layer, w.add(c), s.add(w);
        var t = e("#" + d.selectors.canvas_minutes).width(), n = new Kinetic.Stage({
            container: d.selectors.canvas_minutes,
            width: t,
            height: t
        });
        h = new Kinetic.Shape({
            drawFunc: function (o) {
                var s = e("#" + d.selectors.canvas_minutes).width(), t = s / 2 - d.minutes.borderWidth / 2, n = s / 2, a = s / 2;
                o.beginPath(), o.arc(n, a, t, r(0), r(6 * i.minutes)), o.fillStrokeShape(this), e(d.selectors.value_minutes).html(60 - i.minutes)
            }, stroke: d.minutes.borderColor, strokeWidth: d.minutes.borderWidth
        }), v = new Kinetic.Layer, v.add(h), n.add(v);
        var a = e("#" + d.selectors.canvas_hours).width(), y = new Kinetic.Stage({
            container: d.selectors.canvas_hours,
            width: a,
            height: a
        });
        l = new Kinetic.Shape({
            drawFunc: function (o) {
                var s = e("#" + d.selectors.canvas_hours).width(), t = s / 2 - d.hours.borderWidth / 2, n = s / 2, a = s / 2;
                o.beginPath(), o.arc(n, a, t, r(0), r(360 * i.hours / 24)), o.fillStrokeShape(this), e(d.selectors.value_hours).html(24 - i.hours)
            }, stroke: d.hours.borderColor, strokeWidth: d.hours.borderWidth
        }), b = new Kinetic.Layer, b.add(l), y.add(b);
        var _ = e("#" + d.selectors.canvas_days).width(), m = new Kinetic.Stage({
            container: d.selectors.canvas_days,
            width: _,
            height: _
        });
        u = new Kinetic.Shape({
            drawFunc: function (o) {
                var s = e("#" + d.selectors.canvas_days).width(), t = s / 2 - d.days.borderWidth / 2, n = s / 2, a = s / 2;
                o.beginPath(), 0 == i.total ? o.arc(n, a, t, r(0), r(360)) : o.arc(n, a, t, r(0), r(360 / i.total * (i.total - i.days))), o.fillStrokeShape(this), e(d.selectors.value_days).html(i.days)
            }, stroke: d.days.borderColor, strokeWidth: d.days.borderWidth
        }), f = new Kinetic.Layer, f.add(u), m.add(f)
    }

    function a() {
        var e = setInterval(function () {
            if (i.seconds > 59) {
                if (60 - i.minutes == 0 && 24 - i.hours == 0 && 0 == i.days)return clearInterval(e), void(void 0 !== _ && _.call(this));
                i.seconds = 1, i.minutes > 59 ? (i.minutes = 1, v.draw(), i.hours > 23 ? (i.hours = 1, i.days > 0 && (i.days--, f.draw())) : i.hours++, b.draw()) : i.minutes++, v.draw()
            } else i.seconds++;
            w.draw()
        }, 1e3)
    }

    var d, i, c, h, l, u, w, v, b, f, y, _;
    e.fn.final_countdown = function (s, r) {
        if (y = e(this), y.is(":visible")) {
            var i = e.extend({
                start: void 0,
                end: void 0,
                now: void 0,
                selectors: {
                    value_seconds: ".clock-seconds .val",
                    canvas_seconds: "canvas-seconds",
                    value_minutes: ".clock-minutes .val",
                    canvas_minutes: "canvas-minutes",
                    value_hours: ".clock-hours .val",
                    canvas_hours: "canvas-hours",
                    value_days: ".clock-days .val",
                    canvas_days: "canvas-days"
                },
                seconds: {borderColor: "#7995D5", borderWidth: "2"},
                minutes: {borderColor: "#ACC742", borderWidth: "2"},
                hours: {borderColor: "#ECEFCB", borderWidth: "2"},
                days: {borderColor: "#FF9900", borderWidth: "2"}
            }, s);
            d = e.extend({}, i, s), void 0 === d.start && (d.start = y.data("start")), void 0 === d.end && (d.end = y.data("end")), void 0 === d.now && (d.now = y.data("now")), y.data("border-color") && (d.seconds.borderColor = d.minutes.borderColor = d.hours.borderColor = d.days.borderColor = y.data("border-color")), d.now < d.start && (d.start = d.now, d.end = d.now), d.now > d.end && (d.start = d.now, d.end = d.now), "function" == typeof r && (_ = r), o(), t(), n(), a()
        }
    }
}(jQuery);