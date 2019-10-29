import React, {useCallback} from 'react';
import Grid from '@material-ui/core/Grid';
import firebase from './firebase';
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import Background from './map_back.png';

export default class CommentsPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      image: null,
      info: null,
      comments: [],
    };
  }

  addComment = () => {
    const id = this.props.match.params.id;
    const text = this.state.text;
    const submit = false;
    if(text!=null){
      firebase.database().ref('comments').push().set({
        id,
        content: this.state.text || '',
      });
      this.submit = true;
    }

  };

  componentDidMount() {
    const id = this.props.match.params.id;
    console.log(id);
    firebase.database().ref(`images/${id}`).on('value', (snapshot) => {
      console.log(snapshot.val());
      this.setState({ info: snapshot.val()});
    });
    firebase.storage().ref(`images/${id}.jpg`).getDownloadURL().then(url => {
      console.log(url);
      this.setState({
        image: url,
      });
    }).catch(e => console.log(e));
    firebase.database().ref(`comments`).on('value', (snapshot) => {
      console.log(snapshot.val());
      if (snapshot.val()) {
        let comments = Object.keys(snapshot.val()).map(key => ({
          key,
          ...snapshot.val()[key],
        }));
        console.log(comments);
        comments = comments.filter(item => item.id === id);
        console.log(comments);
        this.setState({
          comments,
        });
      }
    });

  }



  render() {
    const {
      image,
      info,
      comments,
    } = this.state;
    return (
      <div style={{ width: '100%', height: '90hv', display: 'flex', flex: 1, flexDirection: 'column'}}>
        <div style={{ backgroundColor: "#505FB5", width: '100%',
          display: 'flex', flex: 1, flexDirection: 'row', justifyContent: 'space-between'}}>
          <div>
            <p style={{ color: "white", fontSize: 25, marginLeft: 30, fontWeight: 700, marginRight: 10,
            marginTop: 12, marginBottom: 12}}>Comments</p>
          </div>
          <a style={{ color: "white", fontStyle: 'italic', fontSize: 25, marginRight: 20, fontWeight: 700, marginTop: 12, marginBottom: 12 }}
             href='#'
             onClick={() => {this.props.history.push(''); }}>Graffiti</a>

        </div>
        <Grid container>
          <Grid item xs style={{ padding: 30}}>
            {image &&<img src={image} alt="logo"  style={{ width: '100%', display:'flex', flex: 1 }} />}
            {info && <div style={{marginTop: 10, textDecorationLine: 'underline', fontStyle:"italic"}}>
              Description: {info.description}</div>}
          </Grid>
          <Grid item xs style={{ padding: 20 }}>
            {comments.map(item => (
                <div key={item.key}
                     style={{margin: 20, padding: 5, backgroundColor:'rgba(236, 236, 236, 0.7)', borderRadius: 7,}}>
                  <p style={{ marginLeft: 5}}>{item.content}</p>
                </div>
            ))}
            <form autoComplete={false} style={{ flex: 1, flexDirection: 'column', display: 'flex', justifyContent: 'center', }}>
              <h3 style={{ marginLeft: 20, marginRight: 20, marginBottom: 0 }}>Add your comment below</h3>
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
                style={{ marginLeft: 20 , marginRight: 20 }}
                margin="normal"
                variant="outlined"
              />
              <div style={{display: 'flex', flexDirection: 'row', justifyContent: 'space-between'}}>
                  <Button variant="outlined" color="primary"
                          onClick={() => {
                            this.addComment();
                            if(this.submit){
                              this.props.history.go(0);
                            }else{
                              window.alert("Operation failed: the new comment cannot be void");
                            }
                          }}
                          style={{ marginLeft: 20, width: 200, backgroundColor: '#505FB5', color:"white"}}>
                    Submit
                  </Button>
                <Button variant="outlined" color="secondary" onClick={() => {
                  this.props.history.push('');
                }} style={{ marginRight: 20, width: 200 }}>
                  Cancel
                </Button>
              </div>
            </form>
          </Grid>
        </Grid>
      </div>
    );
  }
}
