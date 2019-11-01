import React from 'react';
import TextField from "@material-ui/core/TextField";
import firebase from './firebase';
import Button from "@material-ui/core/Button";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useParams,
  withRouter,
} from "react-router-dom";

// this class is to show the comment page and add new comment to a post
class NewCommentPage extends React.Component {
  // use this function to add new comment and store new comments in the database
  addComment = () => {
    const id = this.props.match.params.id;
    firebase.database().ref('comments').push().set({
      id,
      content: this.state.text || '',
    });
    this.props.history.goBack();
  };

  render() {
    return (
      <form autoComplete={false} style={{ flex: 1, flexDirection: 'column', display: 'flex', justifyContent: 'center', }}>
        <h3 style={{ margin: 20 }}>Add your comment below</h3>
        <TextField
          ref={c => this.input = c}
          id="outlined-multiline-static"
          label="comment"
          multiline
          onChange={e => this.setState({
            text: e.target.value,
          })}
          rows="4"
          placeholder="comment"
          defaultValue=""
          style={{ marginLeft: 20, marginRight: 20 }}
          margin="normal"
          variant="outlined"
        />
        <div>
          <Button variant="outlined" color="primary" onClick={() => {
            this.addComment();
          }} style={{ marginLeft: 20, width: 200 }}>
            Submit
          </Button>
          <Button variant="outlined" color="secondary" onClick={() => {
            this.props.history.push('');
          }} style={{ marginLeft: 20, width: 200 }}>
            Cancel
          </Button>
        </div>
      </form>
    )
  }
}

export default withRouter(NewCommentPage);
