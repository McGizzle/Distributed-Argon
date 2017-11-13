module Utils(
Files,getFiles,
plog,log,
Command,
runArgon
) where

import System.IO
import Control.Monad.State
import System.FilePath
import Control.Distributed.Process
import Prelude hiding (log)
import System.Process
import System.Directory

-- FILES
type Files = [FilePath]

getFiles :: FilePath -> IO Files
getFiles path = fmap (\ f -> path ++ "/" ++ f) . filter (\ f -> head f /= '.') <$> getDirectoryContents path

-- LOG
log :: String -> IO ()
log = liftIO . putStrLn 

plog :: String -> Process ()
plog msg = say $ "-->" ++ msg

-- COMMANDS
type Command = (String,String)

runArgon :: String -> IO String
runArgon file = sendCommand ("stack","exec argon "++file)

sendCommand :: Command -> IO String
sendCommand (cmd,arg) = do
  (_,Just hout,_,_)  <- createProcess (proc cmd $ words arg){ std_out = CreatePipe }
  hGetContents hout

