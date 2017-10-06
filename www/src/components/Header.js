import React from 'react'
import Link from 'gatsby-link'

import './Header.scss'

const Header = ({ children }) => (
  <div className='Header'>
    <div className='Header__content'>
      {children}
    </div>
  </div>
)

export default Header
