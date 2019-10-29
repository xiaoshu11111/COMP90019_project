import React, { Component } from 'react';
import GoogleMapReact from 'google-map-react';
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link
} from "react-router-dom";
import { dbRef } from './firebase';
import './App.css';
import Map from './Map';
import CommentsPage from "./CommentsPage";
import NewCommentPage from "./NewCommentPage";

class App extends Component {
  render() {
    return (
      <Router>
        <div style={{ flex: 1 }}>
          <Switch>
            <Route exact path="/">
              <Map />
            </Route>
            <Route path="/:id/comments" component={CommentsPage} />
            <Route path="/:id/new-comment" component={NewCommentPage} />
          </Switch>
        </div>
      </Router>
    )
  }
}

export default App;
