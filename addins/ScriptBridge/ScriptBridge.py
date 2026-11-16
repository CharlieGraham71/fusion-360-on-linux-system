# ScriptBridge: runs any .py file dropped into ~/fusion-bridge/inbox (Z:\home\graham\fusion-bridge\inbox)
# inside Fusion, then moves it to done/ with a .log of the result.
import adsk.core, adsk.fusion, traceback, threading, os, io, contextlib, shutil, time

INBOX = r'Z:\home\graham\fusion-bridge\inbox'
DONE = r'Z:\home\graham\fusion-bridge\done'
EVENT_ID = 'ScriptBridgeTick'
_app = None
_handlers = []
_stop = threading.Event()
_busy = threading.Lock()

class TickHandler(adsk.core.CustomEventHandler):
    def notify(self, args):
        if not _busy.acquire(blocking=False):
            return
        try:
            for name in sorted(os.listdir(INBOX)):
                if not name.endswith('.py'):
                    continue
                src = os.path.join(INBOX, name)
                buf = io.StringIO()
                ok = True
                try:
                    code = open(src, encoding='utf-8').read()
                    g = {'__name__': '__bridge__', 'adsk': adsk, 'app': _app}
                    with contextlib.redirect_stdout(buf):
                        exec(compile(code, name, 'exec'), g)
                except Exception:
                    ok = False
                    buf.write('\n' + traceback.format_exc())
                stamp = time.strftime('%H%M%S')
                shutil.move(src, os.path.join(DONE, stamp + '_' + name))
                with open(os.path.join(DONE, stamp + '_' + name + ('.ok.log' if ok else '.err.log')), 'w', encoding='utf-8') as f:
                    f.write(buf.getvalue())
        except Exception:
            pass
        finally:
            _busy.release()

def _poll():
    while not _stop.wait(1.0):
        try:
            if any(n.endswith('.py') for n in os.listdir(INBOX)):
                _app.fireCustomEvent(EVENT_ID, '')
        except Exception:
            pass

def run(context):
    global _app
    _app = adsk.core.Application.get()
    os.makedirs(INBOX, exist_ok=True); os.makedirs(DONE, exist_ok=True)
    ev = _app.registerCustomEvent(EVENT_ID)
    h = TickHandler(); ev.add(h); _handlers.append(h)
    _stop.clear()
    threading.Thread(target=_poll, daemon=True).start()

def stop(context):
    _stop.set()
    try:
        _app.unregisterCustomEvent(EVENT_ID)
    except Exception:
        pass
