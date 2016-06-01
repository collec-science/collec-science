
/**
 * Fonction qui supprime le style
 
 * @access	public
 * @return	boolean										False à tous les coups
 */
function gereStyle() {
	var head = document.getElementsByTagName('head')[0]; 
	var link = head.getElementsByTagName('link');
	if (link.length > 0) {
		head.removeChild(link[0]);
	} else {
		link = document.createElement('link');
		link.setAttribute('rel', 'stylesheet');
		link.setAttribute('href', 'css/styles.css');
		link.setAttribute('type', 'text/css');
		head.appendChild(link);	
	}
	return false;
}