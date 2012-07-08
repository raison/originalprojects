var uservoiceOptions = {
  /* required */
  key: 'originalprojects',
  host: 'originalprojects.uservoice.com',
  forum: '35421',
  showTab: true,
  /* optional */
  alignment: 'left',
  background_color:'#767e83',
  text_color: 'white',
  hover_color: '#258ABA',
  lang: 'en'
};

function _loadUserVoice() {
  var s = document.createElement('script');
  s.setAttribute('type', 'text/javascript');
  s.setAttribute('src', ("https:" == document.location.protocol ? "https://" : "http://") + "cdn.uservoice.com/javascripts/widgets/tab.js");
  document.getElementsByTagName('head')[0].appendChild(s);
}
_loadSuper = window.onload;
window.onload = (typeof window.onload != 'function') ? _loadUserVoice : function() { _loadSuper(); _loadUserVoice(); };