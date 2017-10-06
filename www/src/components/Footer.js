import React from 'react'
import { Icon } from 'semantic-ui-react'

import './Footer.scss'

const Footer = () => (
  <div className='Footer'>
    <div className='Footer__content'>
      Designed with <Icon name='heart' />
      by <a href='https://avinash.dwarapu.me'>Avinash Dwarapu</a>.
    </div>
  </div>
)

export default Footer
