<%*
s = tp.file.selection()
if (!s) {
  e = app.workspace.activeLeaf.view.editor
  p = e.getCursor().line
  s = e.getLine(p)
}
navigator.clipboard.writeText(s)
return ""
%>
