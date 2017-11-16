module Main where

import Control.Distributed.Process
import Control.Distributed.Process.Backend.SimpleLocalnet
import Control.Distributed.Process.Closure
import Control.Distributed.Process.Node                   (initRemoteTable)
import Control.Monad
import Network.Transport.TCP                              (createTransport,defaultTCPParameters)
import System.Environment                                 (getArgs)
import System.Exit
import System.FilePath

import Prelude hiding (log)

import Lib 
import Utils

startManager :: FilePath -> String -> String -> IO ()
startManager path host port = do
  backend <- initializeBackend host port rtable
  startMaster backend $ \workers -> do
    result <- manager path workers
    terminateAllSlaves backend
    liftIO $ putStrLn $ "RESULT:\n" ++ result
  return ()

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["worker", host, port] -> do
      putStrLn "Starting Node as Worker"
      backend <- initializeBackend host port rtable
      startSlave backend    
    ["manager", path, host, port]  -> do 
      putStrLn "Satrting Manager Node"
      startManager path host port
    _ -> putStrLn "Bad parameters"
