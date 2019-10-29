import React from 'react';
import Icon from "@material-ui/core/Icon";

class Marker extends React.Component {
  componentDidMount() {

  }

  render() {
    const style = this.props.$hover ? {fontSize: 22} : {fontSize: 18};
    const color_set = this.props.$hover ? "primary" : "secondary";
    return (
      <div>
        <Icon
          color= {color_set}
          style= {style}
        >
          star
        </Icon>
      </div>
    );
  }
}

export default Marker;
