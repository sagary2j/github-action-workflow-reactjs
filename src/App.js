import logo1x from './amp-120px.png';
import logo2x from './amp-120px@2x.png';
import './App.css';

function App() {
  return (
    <>
      <header>
        <img src={logo1x} srcSet={`${logo1x}, ${logo2x} 2x`} className="logo" alt="logo" />
        <div className="shadow"></div>
      </header>
      <footer>
        &copy; 2021 <a href="https://www.woven-planet.global">Woven Planet</a>
      </footer>
    </>
  );
}

export default App;
