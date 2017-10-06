import React from 'react'
import { Container } from 'semantic-ui-react'
import Header from '../components/Header'
import Footer from '../components/Footer'

import './SimplePage.scss'

const SimplePage = ({ children }) => (
  <div className='SimplePage'>
    <Header />
    <Container className='SimplePage__content' text>
      {children}
    </Container>
    <Footer />
  </div>
)

export default SimplePage
