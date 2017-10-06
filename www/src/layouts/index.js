import React from 'react'
import PropTypes from 'prop-types'
import Helmet from 'react-helmet'

import 'prismjs/themes/prism-okaidia.css'
import 'semantic-ui-css/semantic.css'

const TemplateWrapper = ({ children }) => (
  <div>
    <Helmet title='Redd' />
    {children()}
  </div>
)

TemplateWrapper.propTypes = {
  children: PropTypes.func
}

export default TemplateWrapper
