import Header from "./header";
import Title from "../components/title";
export default function Layout({ children }) {
  return (
    <div>
      <Header />
      <div className="w-1/2 my-4 mx-auto text-center">
        <Title />
        {children}
      </div>
    </div>
  );
}
