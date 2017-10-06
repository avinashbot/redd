import React from 'react'
import Link from 'gatsby-link'
import { Button, Icon, Container, Divider } from 'semantic-ui-react'
import Header from '../components/Header'
import Footer from '../components/Footer'

import logo from '../../assets/logo.png'
import './index.scss'

const MainPage = () => (
  <div className='MainPage'>
    <Header />

    <Container className='MainPage__content' text>
      <div className='MainPage__header'>
        <img src={logo} className='MainPage__logo' />
        <h2 className='MainPage__subtitle'>
          A batteries-included API wrapper for reddit.
        </h2>

        <Divider />

        <p>
          <Link to='/tutorials/'>
            <Button size='huge' color='orange'>
              <Icon name='book' /> Docs
            </Button>
          </Link>

          <a href='http://www.rubydoc.info/github/avinashbot/redd/master'>
            <Button size='huge' basic color='green'>
              <Icon name='info circle' /> RubyDoc
            </Button>
          </a>

          <a href='https://www.github.com/avinashbot/redd'>
            <Button size='huge' basic color='blue'>
              <Icon name='github' /> GitHub
            </Button>
          </a>
        </p>
      </div>
    </Container>

    <Footer />
  </div>
)

export default MainPage
