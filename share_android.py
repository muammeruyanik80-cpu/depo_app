import os
try:
    from jnius import autoclass
    from android import mActivity
except Exception:
    autoclass = None
    mActivity = None

def share_file_android(file_path, mime_type='text/csv'):
    if not os.path.exists(file_path):
        return False
    if autoclass is None or mActivity is None:
        return False

    Intent = autoclass('android.content.Intent')
    Uri = autoclass('android.net.Uri')
    File = autoclass('java.io.File')
    PythonActivity = mActivity

    file_obj = File(file_path)
    uri = Uri.fromFile(file_obj)
    intent = Intent()
    intent.setAction(Intent.ACTION_SEND)
    intent.putExtra(Intent.EXTRA_STREAM, uri)
    intent.setType(mime_type)
    chooser = Intent.createChooser(intent, autoclass('java.lang.CharSequence')('Paylaş'))
    chooser.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    PythonActivity.startActivity(chooser)
    return True