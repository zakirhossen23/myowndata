async function Headers(res){
    try {
        res.setHeader('Access-Control-Allow-Credentials', true)
        res.setHeader('Access-Control-Allow-Origin', '*')
        // another common pattern
        // res.setHeader('Access-Control-Allow-Origin', req.headers.origin);
        res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT')
        res.setHeader('x-Trigger', 'CORS')
        res.setHeader(
          'Access-Control-Allow-Headers',
          'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type,Origin, Date, X-Api-Version,Authorization, X-API-KEY, Cache-Control, Pragma,Access-Control-Allow-Request-Method'
        )
    } catch (error) {
        console.log(error)
    }
 
}

export default Headers;