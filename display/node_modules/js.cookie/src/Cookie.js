let Cookie = {

  get: function( name ){
    let match = document.cookie.match( `(^|;) ?${ name }=([^;]*)(;|$)` );
    let value = match ? unescape( match[2] ) : match;
    try      { value = JSON.parse( value ); }
    catch(e) {}
    return value;
  },

  set: function( name, value, options = {} ){
    let cookie = `${ name }=${ escape( JSON.stringify( value ) ) }; path=${ options.path ? escape( options.path ) : `/` }`;
    if ( options.domain )  cookie += `; domain=${ escape( options.domain ) }`;
    if ( options.secure )  cookie += `; secure`;
    if ( options.expires ) cookie += `; expires=${ options.expires }`;
    if ( options.live )    cookie += `; expires=${ expiresFromLive( options.live ) }`;
    document.cookie = cookie;
    return value;
  },

  remove: function( name ){
    let value = this.get( name );
    this.set( name, value, { live: -1 } );
    return value;
  }

}


function expiresFromLive( live ){
  let date = new Date;
  date.setDate( date.getDate() + parseInt( live ) );
  date.setMinutes( date.getMinutes() - date.getTimezoneOffset() );
  return date.toUTCString();
}


export default Cookie;
