import React from 'react'
import 'semantic-ui-css/semantic.min.css'

const html = ({ headComponents, css, body, postBodyComponents }) => (
  <html lang='en'>
    <head>
      <meta charset='utf-8' />
      <meta http-equiv='x-ua-compatible' content='ie=edge' />
      <meta name='viewport' content='width=device-width, initial-scale=1.0' />
      <title>Redd</title>
      {headComponents}
      {css}
    </head>
    <body>
      <div id='___gatsby' dangerouslySetInnerHTML={{ __html: body }} />
      {postBodyComponents}
    </body>
  </html>
)

export default html
