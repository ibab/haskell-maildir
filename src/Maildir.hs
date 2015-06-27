{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}

module Maildir where

import Data.Text
import Control.Monad.Reader
import Control.Monad.IO.Class
import Control.Monad.Trans

createMode = 0700
separator = ":"

data MailboxInfo = MailboxInfo { path :: !Text }

newtype MaildirT m a = MaildirT { unMaildir :: ReaderT MailboxInfo m a }
        deriving (Functor, Applicative, Monad, MonadIO, MonadReader MailboxInfo)

type Maildir = MaildirT IO

runMaildir path m = do
    let mbinfo = MailboxInfo path
    let rd = unMaildir m
    runReaderT rd mbinfo

instance MonadTrans MaildirT where
    lift = MaildirT . unMaildir . lift 

class Monad m => MonadMaildir m where
    initialize :: m ()

instance MonadIO m => MonadMaildir (MaildirT m) where
    initialize = do
        mbinfo <- ask
        let dir = path mbinfo
        liftIO $ putStrLn $ unpack dir

