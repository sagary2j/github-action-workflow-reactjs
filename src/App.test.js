import { render, screen } from '@testing-library/react';
import App from './App';

test('renders copyright link link', () => {
  render(<App />);
  const linkElement = screen.getByText(/Woven Planet/i);
  expect(linkElement).toBeInTheDocument();
});
