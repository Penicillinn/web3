export default function Card({ children }) {
  return (
    <div className="w-full border-1 border-[#eeeeee] rounded-md py-3 px-5 text-left">
      {children}
    </div>
  );
}
